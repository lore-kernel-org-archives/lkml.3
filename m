Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3FMXmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:42:45 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:36456 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3FMXmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:42:44 -0400
MIME-Version: 1.0
In-Reply-To: <1371163963.5555.25.camel@pasglop>
References: <CACxGe6sE5qm5CmGxO8p1dR9v7bbqipm5pYRz8F6pQdWVHetCgA@mail.gmail.com>
 <1371163963.5555.25.camel@pasglop>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 14 Jun 2013 00:42:23 +0100
X-Google-Sender-Auth: 7zC14HlPK_Ay6HGxFKVXmZg-0Oc
Message-ID: <CACxGe6t=dwkd8q3m2QgMt0dnOfyBDJk_eRo70S-_wXM7Sj1ZWw@mail.gmail.com>
Subject: Re: [GIT PULL] devicetree bugfixes for v3.10
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <SWarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 11:52 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2013-06-13 at 23:22 +0100, Grant Likely wrote:
>> Grant Likely (2):
>>       dtc: Update generated files to output from Bison 2.5
>>       dtc: ensure #line directives don't consume data from the next
>
> Question. Are those fixes also in the upstream dtc from jdl ? Or have we
> effectively forked it ?

cherry picked from dtc. In v3.11 we'll need a full resync from jdl.

g.
