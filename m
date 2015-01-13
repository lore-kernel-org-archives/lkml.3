Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbbAMMeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:34:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:44752 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbAMMeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:34:14 -0500
Date: Tue, 13 Jan 2015 13:33:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v2 01/40] x86/uaccess: fix sparse errors
In-Reply-To: <1420558883-10131-2-git-send-email-mst@redhat.com>
Message-ID: <alpine.DEB.2.11.1501131333410.5526@nanos>
References: <1420558883-10131-1-git-send-email-mst@redhat.com> <1420558883-10131-2-git-send-email-mst@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2015, Michael S. Tsirkin wrote:

> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
> 
> Fix that up using __force.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
