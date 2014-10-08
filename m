Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaJHWxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:53:19 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42026 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaJHWxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:53:15 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:91a6:e9a:69b6:c0e5]
In-Reply-To: <28BDD8F7-F896-4A3E-AED8-593737A39877@zytor.com>
References: <1412797764-11466-1-git-send-email-pefoley2@pefoley.com> <28BDD8F7-F896-4A3E-AED8-593737A39877@zytor.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Wed, 8 Oct 2014 18:52:53 -0400
Message-ID: <CAOFdcFNH99kgWv08r2rB-fKKoQcY6JD1i2AZBAC2d3jnb=zhCA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: fix vdso_standalone_test_x86 on 32-bit
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        jkosina@suse.cz, luto@amacapital.net, jwboyer@fedoraproject.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 3:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> This still has the cross-build problems, no?
>

Yes, but that issue is more general to CONFIG_BUILD_DOCSRC.
This is just a build failure on x86-32.
