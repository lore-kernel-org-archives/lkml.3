Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaLANd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:33:56 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:57897 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbaLANdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:33:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: suravee.suthikulpanit@amd.com, mark.rutland@arm.com, will.deacon@arm.com,
        marc.zyngier@arm.com, catalin.marinas@arm.com, liviu.dudau@arm.com,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH 1/2] arm64: amd-seattle: Fix dma-ranges property
Date: Mon, 01 Dec 2014 14:33:42 +0100
Message-ID: <2316008.jChdsJ8v0y@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417405600-19232-2-git-send-email-suravee.suthikulpanit@amd.com>
References: <1417405600-19232-1-git-send-email-suravee.suthikulpanit@amd.com> <1417405600-19232-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WcMtMoMKweVm0rJWPHCQwaNNsWWAY88RvZQKpelPqCE
 tnvT+RmBPiegz2LVuxHqW3ICsZhgYe3dReC1xWe8ieAoOw4TXP
 B4FyAbU1rmNpe0yHt7FwRHc3HB8oPFoDXndfduMEVdLTiOgLSd
 6xHLXUi5PHpYPgvXaptpjifsz2kNP9oErPKDLUGzraQ3X3QiwD
 NTQzfSNjDs3AjzaUtucSGx7DjqzM2QMZRNYs1Ow0RHG+fi2U7i
 wL7OdpaOI7tWq3OcbL5wg71Bl5vRDpq9uFx7lHYE0/Zc6ZIP0U
 3VHFMBp1LriU148WnJSRVX0tslBme4vbX8ar2JZZ5E+W4rDYXJ
 BJpTIDX2PYAsyTxbi+5Q=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 November 2014 21:46:39 suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> AMD Seattle should support 40-bit DMA.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 

The change looks good, but two things about the patch description:

- You should be a little more verbose, especially after we had discussed
  this to some detail on IRC, explain why you use the specific values.

- You should configure git-send-email to know your full email address
  including the name. Right now it gets sent from
  "suravee.suthikulpanit@amd.com" instead of "Suravee Suthikulpanit
  <Suravee.Suthikulpanit@amd.com>", and that causes the extra From
  line at the start of the mail, besides looking a bit strange.

Thanks,

	Arnd
