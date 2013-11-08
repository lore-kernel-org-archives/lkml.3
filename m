Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3KHNwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 08:52:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3KHNwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 08:52:46 -0500
Message-ID: <527CECA8.5030408@suse.cz>
Date: Fri, 08 Nov 2013 14:52:40 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [PATCHv2] coccinelle: Add a script to find unnecessary ifs with
 no body
References: <20131102143236.GA18084@leaf> <alpine.DEB.2.02.1311021550330.2261@hadrien> <20131102151500.GW15704@leaf> <alpine.DEB.2.02.1311021748590.2261@hadrien>
In-Reply-To: <alpine.DEB.2.02.1311021748590.2261@hadrien>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.11.2013 17:49, Julia Lawall wrote:
>> +@r depends on report || context@
>> +expression E;
>> +position p;
>> +@@
>> +if@p (E) {}
> 
> There should be a * in front of the if, to support context mode.

Josh, will you send a v3 with the above fix?

Thanks,
Michal

