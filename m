Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3FXRVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:21:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3FXRVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:21:36 -0400
Message-ID: <51C87FBD.2000501@ontolinux.com>
Date: Mon, 24 Jun 2013 19:19:57 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows NT 5.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andreas Karlsson <andreas@proxel.se>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: Tux3 Report: Meet Shardmap, the designated successor of HTree
References: <1EC23D2B9975384993D85B5DB93AAE8860E5A2@sisaex02sj> <51C353C6.2070406@ontolinux.com> <20130624141835.GA23245@amd.pavel.ucw.cz> <51C862CC.1010606@ontolinux.com> <51C86817.6030304@proxel.se>
In-Reply-To: <51C86817.6030304@proxel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:D1Rh6PfQSZUq5m331IfoTpOBsVGcTu5EohJQerel5gy
 nTfRFEV0wSr4fy5QkpFp87cWU/7D3vGc8cAylS5CKMH5YRM3uM
 6tabEVb4IAxCfr8lSts9lo2xnonEvps3upuc1nslB6J6LSiAKZ
 MxJxLE+MYyC5zjDppp54mcsKGuo483laUfiSmvPEljpQHKmfOi
 v0FI6aAVzzXhFl4HJROqwhDeoowTRKcbkMPEboez2RPDLBEt/d
 qgEod1RWnODlVqTqap3WhfrXtuQqEHx1hnsacMV+ekytA3dCCP
 jwANn91UPd5FSldC3szr9LS2+x0aTcyjGu2JgVc2NVmVtK5bJJ
 P8M362oWzlLKK+MKE9ro=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Andreas Karlsson:

Thank you for the quote. If we really want to bring this down to the 
lowest level, then an idea is not copyrighted per se, for sure.

But, what is the problem? That I have used the wrong word? The context 
was clear and hence the meaning of the word "ideas". So, simply add the 
word "described", "presented", or "publicated" before the word "ideas" 
or substitute the word "ideas" with the term "technical descriptions 
given in textual form".

Or is the problem that the idea has been publicated and everybody is now 
free to take it? The answer is: yes and no.
Yes:
Everybody can implement an idea, concept, system, or method of operation 
even if it is given with a copyrighted representation, and give it away 
or even sell it, because in the latter case it is not patented. But how 
should somebody give something away or sell something without giving a 
description about what it is? This leads to the other case.

No:
What you and many other persons might misunderstand is the fact that if 
an idea is copyrighted by being represented in a textual, visual, or 
other form, it even does not matter at all if somebody else takes 
another text or image as long as the sense/the idea described in this 
other way is still the same as described in the original text or image, 
because it does not matter in which way the copyrighted thing is 
communicated. As a good example take a melody publicated with written 
notes. It does not matter on which instrument you play it or in which 
style you sing it. It is still the same melody. Or take a written script 
of a movie that is narrated from the view of the main protagonist in the 
original plot and from the view of another actor or a voice in the back 
in a copied plot. In all cases it is still the same copyrighted idea/story.

Said this, every other description or documentation that uses different 
terms, a source code, even a visual graphic, or whatever representation 
of a file system that has the characteristical features of my 
log-structured hashing based data storage system with one or more of the 
optional features like for example consistent hashing, different data 
structures on the physical storage system and in the (virtual) memory, 
finger table, logged finger or hash tables in memory, and ACID 
properties (see again the given links), as it is the case with the 
latest description of the Tux3 FS with Shardmap, transports/communicates 
the copyrighted description of the same idea/concept/system in large 
parts or even as a whole somehow. And simply coding and compiling it 
does not help as well due to the many possibilities of re-engineering.



Regards
Christian Stroetmann

> Hi,
>
> I assume it is serious since ideas cannot be copyrighted in most (or 
> maybe even all) countries.
>
> From the FAQ of the U.S. Copyright Office [1]:
>
> "Copyright does not protect facts, ideas, systems, or methods of 
> operation, although it may protect the way these things are expressed."
>
> "How do I protect my idea?
>
> Copyright does not protect ideas, concepts, systems, or methods of 
> doing something. You may express your ideas in writing or drawings and 
> claim copyright in your description, but be aware that copyright will 
> not protect the idea itself as revealed in your written or artistic 
> work."
>
> Andreas
>
> [1] http://www.copyright.gov/help/faq/faq-protect.html#what_protect
>
> On 06/24/2013 05:16 PM, Christian Stroetmann wrote:
>> Dear Mr. Pavel Machek:
>>
>> Is this a serious comment?
>> Nevertheless, this is a copyrighted idea [1].
>>
>>
>> Sincerely
>> Christian Stroetmann
>>
>> [1] Log-Structured Hash-based File System (LogHashFS or LHFS;
>> www.ontonics.com/innovation/pipeline.htm#loghashfs)
>>
>>> Hi!
>>>
>>>> At first you came up with a file system that can handle a great
>>>> many/billions files and has ACID feature, which are both features of
>>>> my Ontologic File System (OntoFS; see [1]). Both were said to be a
>>>> no-go at that time (around 2007 and 2008).
>>>> Then you came up, with my concept of a log-structured hashing based
>>>> file system [2] and [3], presented it as your invention yesterday
>>>> [4], and even integrated it with your Tux3 file system that already
>>>> has or should have the said features of my OntoFS. I only waited for
>>>> this step by somebody strongly connected with the company Samsung
>>>> since the October 2012. AIso, I do think that both steps are very
>>>> clear signs that shows what is going on behind the curtain.
>>>> And now your are so bold and please me that I should credit these
>>>> ideas in the sense of crediting your ideas. For sure, I always do
>>>> claim for copyright of my ideas, and the true question is if you are
>>>> allowed to implement them at all. In this conjunction, I would give
>>> Fortunately, you can't copyright ideas. Chuck Norris managed to do it
>>> once, but you can't.
>>>
>>> Pavel
>>
>

