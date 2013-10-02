Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3JBGDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:03:09 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49350 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3JBGDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:03:07 -0400
Date: Wed, 2 Oct 2013 08:03:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: sort reboot DMI quirks by vendor.
Message-ID: <20131002060303.GC31122@gmail.com>
References: <20130927203308.GB22836@redhat.com>
 <20130928064030.GA16660@gmail.com>
 <20131001203655.GA10719@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001203655.GA10719@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> Grouping them by vendor should make it easier to spot duplicates.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>

Thanks Dave!

	Ingo
