Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966903Ab3DQWAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:00:45 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35555 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965558Ab3DQWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:00:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAOZdJXVnppPczrJi8jcNWLvabHFWP++Ex1QiEadbyLfApCR85g@mail.gmail.com>
References: <1365564999-24427-1-git-send-email-Yuantian.Tang@freescale.com>
 <D07C73A334FF604B95B3CBD2A545D07B0B144FD3@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130417145719.F194E3E2B73@localhost> <CAOZdJXVnppPczrJi8jcNWLvabHFWP++Ex1QiEadbyLfApCR85g@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 17 Apr 2013 23:00:22 +0100
X-Google-Sender-Auth: nPZC0UP-8Rwymg1xPr061gKhQpE
Message-ID: <CACxGe6usVnOdcxELXWcqtuW-YVvDJmyyW+Ds8UQ1xpoCY+_WAg@mail.gmail.com>
Subject: Re: [PATCH v2] of/base: release the node correctly in of_parse_phandle_with_args()
To: Timur Tabi <timur@tabi.org>
Cc: Tang Yuantian-B29983 <B29983@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 10:52 PM, Timur Tabi <timur@tabi.org> wrote:
> On Wed, Apr 17, 2013 at 9:57 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>>> I really preciate if you can spend some times to review this patch.
>>
>> Applied, thanks.
>
> Pff.  Why do I bother?

Relax Timur:

http://git.secretlab.ca/?p=linux.git;a=commitdiff;h=b855f16b05a697ac1863adabe99bfba56e6d3199

g.



--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
