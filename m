Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3GXTCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:02:25 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:56760 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3GXTCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:02:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+pSmRPqV-5xsEwBM_23sGaci5T6vka1LgTD5aiEoHCbg@mail.gmail.com>
References: <CA+8MBb+pSmRPqV-5xsEwBM_23sGaci5T6vka1LgTD5aiEoHCbg@mail.gmail.com>
Date: Wed, 24 Jul 2013 12:02:21 -0700
Message-ID: <CA+8MBbJUi9Xy1mMivQo=gbk_SRNJ3fzs+mw+hXY+ovVQPXORPA@mail.gmail.com>
Subject: Re: scsi scan: INQUIRY result too short (5), using 36
From: Tony Luck <tony.luck@gmail.com>
To: James Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops ... forgot final step.  That commit does revert cleanly (at least
git did not grumble when I asked it to revert).  The resulting kernel
builds cleanly and boots without seeing this problem.

-Tony
