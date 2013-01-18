Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab3ARQpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:45:09 -0500
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:50873 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750928Ab3ARQpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:45:07 -0500
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,jason@warr.net,:::::::::::,RULES_HIT:355:379:481:599:601:800:854:945:967:972:973:988:989:1187:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3027:3138:3139:3140:3141:3142:3353:3657:3865:3866:3867:3868:3869:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4384:5007:6117:6120:7652:7679:7901:7903:8599:9010:9025:10004:10128:10400:10848:11253:11658:11854:11914:12043:12050:12517:12519:12740:12776,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 6A61736F6E40776172722E6E6574
X-Filterd-Recvd-Size: 2961
Message-ID: <50F97C0F.9010405@warr.net>
Date: Fri, 18 Jan 2013 10:45:03 -0600
From: Jason Warr <jason@warr.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Amit Kale <akale@stec-inc.com>,
        device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD> <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD> <20130116104546.GA3869@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD> <20130117132620.GA2438@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD> <50F844A3.9020300@warr.net> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD> <50F970A3.4000403@warr.net> <20130118161135.GA3118@raspberrypi>
In-Reply-To: <20130118161135.GA3118@raspberrypi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/18/2013 10:11 AM, thornber@redhat.com wrote:
> On Fri, Jan 18, 2013 at 09:56:19AM -0600, Jason Warr wrote:
>> If I can help test and benchmark all three of these solutions please
>> ask.  I have allot of hardware resources available to me and perhaps I
>> can add value from an outsiders perspective.
> We'd love your help.  Perhaps you could devise a test that represents
> how you'd use it?
>
> - Joe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

As much as I dislike Oracle that is one of my primary applications.  I
am attempting to get one of my customers to setup an Oracle instance
that is modular in that I can move the storage around to fit a
particular hardware setup and have a consistent benchmark that they use
in the real world to gauge performance.  One of them is a debit card
transaction clearing entity on multi-TB databases so latency REALLY
matters there.  Hopefully I'll have a couple of them setup within a
week.  At that point I may need help in getting the proper kernel trees
and patch sets munged into a working kernel.  That seems to be the spot
where I fall over most of the time.

Unfortunately I probably could not share this specific setup but it is
likely that I can derive a version from it that can be opened.
