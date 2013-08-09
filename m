Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934413Ab3HIQPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:15:50 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62985 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab3HIQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <520514EE.1060708@calxeda.com>
References: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
	<1375890758-30265-3-git-send-email-mark.langsdorf@calxeda.com>
	<20130809161015.GQ20515@mtj.dyndns.org>
	<520514EE.1060708@calxeda.com>
Date: Fri, 9 Aug 2013 12:15:45 -0400
X-Google-Sender-Auth: RWNElx_MXha6zyESXy3UlTkNXts
Message-ID: <CAOS58YM_1MbngkEvoVtLpJqj3z-fpiQNyog0YK9fdSD7epYYcQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] devicetree: create a separate binding description
 for sata_highbank
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mark.

On Fri, Aug 9, 2013 at 12:12 PM, Mark Langsdorf
<mark.langsdorf@calxeda.com> wrote:
> I'll update the description when I resubmit it to give you more detail on
> the impact.

Yes, please give me some hints on to which branch the patches are
targeted and whether stable should be cc'd. I can't really tell just
looking at the patches as I have no idea how widespread the device is
in the wild and which kernels they'd be running or how critical being
out-of-spec is (is it gonna burn phys on the receiving end in the long
term? or is it just noisier and the link is gonna be more susceptible
to errors from EM interferences and so on) and how risky the fixes
are.

Thanks.

-- 
tejun
