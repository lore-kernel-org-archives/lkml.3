Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3IWU1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:27:47 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38721 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab3IWU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:27:46 -0400
Message-ID: <5240A46B.3080408@metafoo.de>
Date: Mon, 23 Sep 2013 22:28:27 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: of_get_regulation_constraints: Use node name
 as fallback
References: <1379846854-11746-1-git-send-email-lars@metafoo.de> <20130923101551.GY21013@sirena.org.uk>
In-Reply-To: <20130923101551.GY21013@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 12:15 PM, Mark Brown wrote:
> On Sun, Sep 22, 2013 at 12:47:34PM +0200, Lars-Peter Clausen wrote:
>> If the "regulator-name" property is not present use the name of the devicetree
>> node as a fallback.
>
> You're not supposed to use the node name for anything, the goal is that
> it's entirely ornamental noise.  Which is a bit annoying but there we
> are.
>

Is this documented somewhere? I'd be interested in the rationale behind this.
