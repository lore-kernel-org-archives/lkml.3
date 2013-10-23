Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3JWO4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:56:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3JWO4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:56:41 -0400
Message-ID: <5267E3A4.40705@suse.cz>
Date: Wed, 23 Oct 2013 16:56:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>, Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr
Subject: Re: [PATCH] scripts/coccinelle/api: remove devm_request_and_ioremap.cocci
References: <1376562633-16204-1-git-send-email-wsa@the-dreams.de> <20131006134921.GA4173@katana> <alpine.DEB.2.02.1310061552541.2037@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1310061552541.2037@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.10.2013 15:53, Julia Lawall wrote:
> On Sun, 6 Oct 2013, Wolfram Sang wrote:
> 
>> On Thu, Aug 15, 2013 at 12:30:25PM +0200, Wolfram Sang wrote:
>>> Use of this function is discouraged in favour of
>>> devm_ioremap_resource(). Don't advertise it.
>>>
>>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> 
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied to kbuild.git#misc now. For some reason, I overlooked the patch
before.

Michal
