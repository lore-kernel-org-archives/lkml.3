Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3AYUId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:08:33 -0500
Received: from mailer2.psc.edu ([128.182.70.106]:40585 "EHLO mailer2.psc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab3AYUIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:08:31 -0500
X-Greylist: delayed 2010 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 15:08:31 EST
Message-ID: <5102E63E.1020508@psc.edu>
Date: Fri, 25 Jan 2013 15:08:30 -0500
From: rapier <rapier@psc.edu>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: netdev@vger.kernel.org, web10g-user@web10g.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Web10g-user] Web10g TCP statistics patch - mainlining into kernel?
References: <18855.1359138716@turing-police.cc.vt.edu>            <5102DE61.80804@psc.edu> <23149.1359143784@turing-police.cc.vt.edu>
In-Reply-To: <23149.1359143784@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/25/13 2:56 PM, Valdis.Kletnieks@vt.edu wrote:

> I already looked over the patch and it looks *fairly* sane.  Having said
> that, the best way to proceed for the performance side is probably to
> get some rough ballpark numbers and then get the patch into a state
> that's upstream-able before doing the final measurements (because there's
> actually a high likelihood that the final numbers will end up being
> dependent on the exact details of the patch, plus having more eyeballs on
> it from the netdev side may shake out better approaches).
 >
> Sorry if you've already done all that - I didn't see much evidence of
> it from the web10g-user archives...

The user side of the list has been pretty quiet to be sure. Most of the 
discussion happens internal to the team. The primary KIS developer is 
out the office until next week but I'll try to make sure he addresses 
this as soon as he can. I agree entirely with the more eyes approach and 
none of us have a lot of ego sunk into the details of the code in and of 
itself. As researchers, more than anything else, we want the concept 
moved forward. We believe, strongly, that having these metrics in the 
mainline can really do a lot to help the entire user community and spur 
some really neat development.

Chris
