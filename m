Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab3BAWKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:10:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:39006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab3BAWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:09:52 -0500
Message-ID: <510C3D65.6010200@infradead.org>
Date: Fri, 01 Feb 2013 14:10:45 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] SubmittingPatches: add penalty for forcing a maintainer
 to edit a patch
References: <20130201154306.GA28473@kroah.com> <1359733687.17807.7.camel@joe-AO722> <CAJL_dMuMnq0=4vv0GriQqUhwnR=gwcnok3rXTsanVYZ5cdLfkQ@mail.gmail.com>
In-Reply-To: <CAJL_dMuMnq0=4vv0GriQqUhwnR=gwcnok3rXTsanVYZ5cdLfkQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/13 13:07, Anca Emanuel wrote:
> Joe, read lkml and decide after that.
> I fully apove the pathch.
> 
> Reviewed-by: Anca Emanuel <anca.emanuel@gmail.com>
> 
> Review-requested-by: Joe Perches <joe@perches.com>
> 
> 
> Comments:
> You have 3 kernels to maintain as stable, plus drivers, plus etc.
> If somebody post something without reading the docs, and you have to
> repeat to them the same, again and more, then you MUST give an beer.

If someone is a repeat-repeat offender, they should just learn
how to submit patches correctly.  I.e., the maintainer should just
keep saying to them, Sorry, please submit your patch correctly
so that I can apply it.


> On Fri, Feb 1, 2013 at 5:48 PM, Joe Perches <joe@perches.com> wrote:
>> On Fri, 2013-02-01 at 16:43 +0100, Greg Kroah-Hartman wrote:
>>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> Maintainers have to hand-edit patches (body of patches and changelog
>>> entries) all the time.  There needs to be some kind of penalty put into
>>> place to keep developers from abusing maintainers.
>>
>> No, there doesn't.
>>
>> It's funny as a joke, it's not as an actual patch.


-- 
~Randy
