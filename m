Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbaJ3AfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:35:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:47886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbaJ3AfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:35:08 -0400
Message-ID: <545187B6.1090704@infradead.org>
Date: Wed, 29 Oct 2014 17:35:02 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Triplett <josh@joshtriplett.org>
CC: Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: Add a chapter on conditional compilation
References: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org> <CAMuHMdV2Z0+gon8+LP_7X2h4B4Hb3KAV2vpZ9kRwC2mVFGLWXw@mail.gmail.com>
In-Reply-To: <CAMuHMdV2Z0+gon8+LP_7X2h4B4Hb3KAV2vpZ9kRwC2mVFGLWXw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/14 12:12, Geert Uytterhoeven wrote:
> On Wed, Oct 29, 2014 at 7:15 PM, Josh Triplett <josh@joshtriplett.org> wrote:
>> Document several common practices and conventions regarding conditional
>> compilation, most notably the preference for ifdefs in headers rather
>> than .c files.
>>
>> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> 
>> +If you have a function or variable which may potentially go unused in a
>> +particular configuration, and the compiler would warn about its definition
>> +going unused, mark the definition as __maybe_unused rather than wrapping it in
>> +a preprocessor conditional.  (However, if a function or variable *always* goes
>> +unused, delete it.)
> 
> Personally, I don't like __maybe_unused. Once it's there, the compiler
> will stop warning about it, even if it really becomes unused.
> 
> Apart from that:
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Is the compiler smart enough to delete (discard) the code or data instance
if it is unused or is the code or data actually wasting space?


-- 
~Randy
