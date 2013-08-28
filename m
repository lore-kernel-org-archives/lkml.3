Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3H1PIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:08:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab3H1PIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:08:40 -0400
Message-ID: <521E1275.9070606@suse.cz>
Date: Wed, 28 Aug 2013 17:08:37 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yang, Fei" <fei.yang@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: Re: Can anyone suggest a better fix? Not sure if I understand the
 problem, but the patch fixed it
References: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com> <20130826201035.GA21141@merkur.ravnborg.org> <02E7334B1630744CBDC55DA85862258348E458D8@ORSMSX102.amr.corp.intel.com> <521E1232.6010501@suse.cz>
In-Reply-To: <521E1232.6010501@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.8.2013 17:07, Michal Marek wrote:
> Are you able to reproduce this with the vanilla kernel? If so, details
> please. If not, then this can be something with your module's build
> system. Are you using anything fancier than
> 
> $ cat Makefile
> obj-m += my-module.o
> $ make -C <kernel build tree> M=$PWD

make -C <kernel build tree> M=$PWD modules

Michal

