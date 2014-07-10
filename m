Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaGJLb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:31:29 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:58334 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaGJLb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:31:27 -0400
X-Auth-Info: DUAKk9CO9MmGJ/7m2Nw+LrWZDbCg1Uwd1iVjEVYcXg0=
From: Marek Vasut <marex@denx.de>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: Re: [PATCH v3 1/3] ima: use ahash API for file hash calculation
Date: Thu, 10 Jul 2014 13:31:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-ima-devel@lists.sourceforge.net,
        "linux-security-module" <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto" <linux-crypto@vger.kernel.org>
References: <cover.1404475462.git.d.kasatkin@samsung.com> <201407101002.07535.marex@denx.de> <53BE7691.3080604@samsung.com>
In-Reply-To: <53BE7691.3080604@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407101331.25786.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 10, 2014 at 01:18:41 PM, Dmitry Kasatkin wrote:
[...]
> > All right, that was my understanding of the entire discussion -- an
> > accelerator dying mid-way and what will IMA do about that.
> > 
> >> But as we fallback to early allocated shash, which is not USB yet,
> >> then there is no problem.
> >> ahash itself does not bring any other additional problem than shash
> >> itself. They are compiled builtin together.
> > 
> > Sure, I understood that. But what will happen if the ahash accelerator
> > stops working mid-flight, will IMA also go bonkers or is there some
> > graceful stop?
> 
> shash fallback will be used.

Ah, thank you for clearing this!

Best regards,
Marek Vasut
