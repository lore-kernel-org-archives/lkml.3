Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422875AbaKNXcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:32:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64173 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422670AbaKNXb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:31:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Ajay Thomas <ajay.thomas.david.rajamanickam@intel.com>,
        Noor U Mubeen <noor.u.mubeen@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: Re: [PATCH v2 0/3] Intel RAPL updates for Atom CPUs
Date: Sat, 15 Nov 2014 00:52:57 +0100
Message-ID: <3477591.WIIFIZbsqP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415381367-16693-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1415381367-16693-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 07, 2014 09:29:24 AM Jacob Pan wrote:
> Running Average Power Limit (RAPL) is supported in Atom processors
> with a slightly different implementation. This patchset abstracts the
> differences and add support for newer ATOM CPUs.
> 
> Intel Software Developers Manual has also been updated with many changes
> and clarifications on how RAPL units and power limits are calculated.
> 
> Changes:
> 	v2: fix 32 bit divide in time window calculation  
> 
> Jacob Pan (3):
>   powercap/rapl: abstract per cpu type functions
>   powercap/rapl: handle atom and core differences
>   powercap/rapl: add new model ids
> 
>  drivers/powercap/intel_rapl.c | 264 ++++++++++++++++++++++++++++--------------
>  1 file changed, 177 insertions(+), 87 deletions(-)

Series queued up for 3.19 (along with the later build fix), thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
