Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3H3PKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:10:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab3H3PKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:10:18 -0400
Message-ID: <5220B5D4.1080807@suse.cz>
Date: Fri, 30 Aug 2013 17:10:12 +0200
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
References: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com> <20130826201035.GA21141@merkur.ravnborg.org> <02E7334B1630744CBDC55DA85862258348E458D8@ORSMSX102.amr.corp.intel.com> <521E1232.6010501@suse.cz> <02E7334B1630744CBDC55DA85862258348E4792D@ORSMSX102.amr.corp.intel.com> <20130829175511.GA23620@merkur.ravnborg.org>
In-Reply-To: <20130829175511.GA23620@merkur.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.8.2013 19:55, Sam Ravnborg wrote:
> Magic happens in Kbuild.include, Makefile.lib and Makefile.build.
> But it make take some cup of coffee to grasp it.
> 
> For find and fix whatever race condition you hit.

BTW, there is a fix in 3.11 that might be relevant for you:

commit 4d47dde47f7dd95042fa56283d948f50dd4b509c
Author: 张忠山 <zzs0213@gmail.com>
Date:   Sun Jun 30 17:09:28 2013 +0800

    kbuild: create directory for dir/file.o

At least, it's worth trying.

Michal
