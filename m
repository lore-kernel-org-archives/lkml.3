Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaLQHxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:53:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaLQHxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:53:04 -0500
Date: Wed, 17 Dec 2014 08:53:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Wu <peter@lekensteyn.nl>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] HID: logitech-dj: check report length
In-Reply-To: <1418745323-17133-1-git-send-email-peter@lekensteyn.nl>
Message-ID: <alpine.LNX.2.00.1412170852410.1680@pobox.suse.cz>
References: <CAN+gG=EL0kYim=_uaS4yj7c_XC8rKa1eELxpVXaOuvnWgT_eQw@mail.gmail.com> <1418745323-17133-1-git-send-email-peter@lekensteyn.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Peter Wu wrote:

> Malicious USB devices can send bogus reports smaller than the expected
> buffer size. Ensure that the length is valid to avoid reading out of
> bounds.
> 
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  v1: patch 2/3 HID: logitech-{dj,hidpp}: check report length
>  v2: splitted original report length check patch

Applied to for-3.19/upstream-fixes.

-- 
Jiri Kosina
SUSE Labs
