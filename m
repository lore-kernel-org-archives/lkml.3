Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344Ab3HNUhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:37:16 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55557 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178Ab3HNUhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:37:14 -0400
Date: Wed, 14 Aug 2013 16:37:09 -0400
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
Subject: Re: [PATCH v4 1/3] devicetree: create a separate binding description
 for sata_highbank
Message-ID: <20130814203709.GL28628@htj.dyndns.org>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
 <1376504612-17340-1-git-send-email-mark.langsdorf@calxeda.com>
 <20130814202728.GJ28628@htj.dyndns.org>
 <520BEA3B.2040005@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BEA3B.2040005@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 03:36:11PM -0500, Mark Langsdorf wrote:
> On 08/14/2013 03:27 PM, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Aug 14, 2013 at 01:23:30PM -0500, Mark Langsdorf wrote:
> >>  Documentation/devicetree/bindings/ata/sata_highbank.txt | 6 ++++--
> >>  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > Any ideas on how these should be routed?  The above doesn't apply to
> > libata or master as the file doesn't exist there yet.
> 
> I accidentally introduced a new commit while cleaning up the patch. The
> correct patch text should have been as follows. Do you want me to resubmit?

Can you please just re-send the corrupt patch?

Thanks.

-- 
tejun
