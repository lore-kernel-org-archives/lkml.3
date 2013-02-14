Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab3BNOSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:18:08 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:59259 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3BNOSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:18:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130213205026.GA25290@phenom.dumpdata.com>
References: <20130213205026.GA25290@phenom.dumpdata.com>
Date: Thu, 14 Feb 2013 09:18:04 -0500
Message-ID: <CA+5PVA7fzT7+O-e8ta4rU4=vLfU+DsEzvLN8-vvMm3o=8FThsg@mail.gmail.com>
Subject: Re: [GIT PULL] (xen) bug-fixes for v3.8-rc7
From: Josh Boyer <jwboyer@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 3:50 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>  - CVE-2013-0228/XSA-42: x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

> Jan Beulich (1):
>       x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Should that one be CC'd to stable?

josh
