Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3IFMI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:08:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3IFMIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:08:55 -0400
Message-ID: <5229C5D4.5070600@redhat.com>
Date: Fri, 06 Sep 2013 08:08:52 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random, Add user configurable get_bytes_random()
References: <1378383524-27983-1-git-send-email-prarit@redhat.com> <20130905144818.GA23661@thunk.org> <52289E6C.8090301@redhat.com> <20130905190334.GC23661@thunk.org> <20130905194907.GE23661@thunk.org>
In-Reply-To: <20130905194907.GE23661@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/05/2013 03:49 PM, Theodore Ts'o wrote:
> BTW, note the following article, published today:
> 
> http://www.nytimes.com/2013/09/06/us/nsa-foils-much-internet-encryption.html?pagewanted=all
> 
> "By this year, the Sigint Enabling Project had found ways inside some
> of the encryption chips that scramble information for businesses and
> governments, either by working with chipmakers to insert back doors...."
> 
> Relying solely and blindly on a magic hardware random number generator
> which is sealed inside a CPU chip and which is impossible to audit is
> a ***BAD*** idea.

Your argument seems to surround the idea that putting stuff on the internet is
safe.  It isn't.  If you've believed that then you've had your head in the sand
and I've got a lot of land in Florida to sell you.

Either way ... it's obvious you're not willing to take this patch and I respect
that decision.

Thanks,

P.
