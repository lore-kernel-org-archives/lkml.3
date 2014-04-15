Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaDOQcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:32:39 -0400
Received: from mano-163-24-shared.jabatus.fr ([109.234.163.24]:58714 "EHLO
	mano-163-27-shared.jabatus.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750849AbaDOQci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:32:38 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 313749343F85.ADCDE
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D5F11.6020108@manux.info>
Date: Tue, 15 Apr 2014 18:32:17 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][4/11][MANUX] Kernel compatibility : ioctl(2)
References: <534D375E.7070308@manux.info> <20140415160035.3135dda7@alan.etchedpixels.co.uk> <534D5795.8080100@manux.info> <20140415170519.75d885fb@alan.etchedpixels.co.uk>
In-Reply-To: <20140415170519.75d885fb@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/04/2014 18:05, One Thousand Gnomes a écrit :
>> I think this is an unproblematic extension, especially since these
>> ioctls are only supposed to be called by low-level software shipped with
>> the OS.
> 
> Thats the excuse everyone gives for messing up standards stuff. It
> usually comes back to bite you later.
> 
> If it's not ioctl don't call it ioctl, have a fdoctl() or something
> 
> Alan
> 

I see your point... Well, this looks like the most staightforward
approach then. I'll go with fdoctl().

Emmanuel
