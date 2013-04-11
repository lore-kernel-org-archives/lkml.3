Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717Ab3DKIEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:04:49 -0400
Received: from smtp.domeneshop.no ([194.63.252.54]:34701 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3DKIEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:04:46 -0400
Message-ID: <51666E94.90607@paradoxuncreated.com>
Date: Thu, 11 Apr 2013 10:04:36 +0200
From: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Millennium Basic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. I have bothered this list, with many of my insights, and now I am 
going to bother you with more.

This may be read in blog-format here: 
http://paradoxuncreated.com/Blog/wordpress/?p=13232

I`ve been thinking about this. When I was 8 years old, I did programming 
believe it or not. Basic-programming, yes, but programming. And in 
hindsight I have been so grateful for that. Somethings I remember about 
basic on the commodore 64 still, is that it lacked freedom from 
linenumbering, and carrying variables into other routines. I remember 
thinking, if it only had that, you could do mostly anything with it.

This was Microsoft Basic v2. And one programmed it directly to hardware, 
with peeks and pokes. Later I also learned assembly-programming. 
Regardless of Microsofts product-ventures later, Basic V2, remains a 
brilliant point in history.

I think that, lies at the foundations of my programming. A very 
interactive and interpreted experience, with the computer, without 
obscure APIs, or any uneccesary learning. Something I carried with me, 
into assembly-programming, and something I still use, when developing my 
DSP plugins, making most variables tunable, and these are worldclass. 
(feel free to listen to the comparison to one of the worlds most 
reknowned mastering-houses - 
http://paradoxuncreated.com/Blog/wordpress/?p=13140)
And I spent much time tuning the variables, and not in any way, would 
these come easily as constants, or untunables in any kind of situation. 
I think programmers rarely do this these days. "A fir of FFT lenght 64 
will do", for instance, from a purely theoretic viewpoint. I know very 
well, that that will not get the optimal results.

I also ofcourse did the low-jitter config, that made doom 3, which John 
Carmack states on Quakecon 2012, that "Doom 3 still tax some 
configurations" - run absolutely smooth on 5 year old hardware. From 
tuning from a high-level perspective, knowing what I do about computers.

Most people I see today, who have good programming habits, usually know 
a little bit about assembly-programming, a "vintage" situation, and that 
of programming directly to the hardware, and some knowledge of 
assembly-instructions.

I fear that is disappearing a bit, in highlevel langauge, the need for 
compilation and APIs that may not be accesible to children or beginners.

A lot of the enthusiasm that drives hacker-circles, and often those 
around linux, is such experience. Not neccesarily from a book, but doing 
programming, intuitively, and really just out from understanding a 
syntax. And a lot of enthusiasm exists around interpreted script 
languages, and is often what drives certain technologies forward.

And since I am now doing some of the best DSP in the world, and also 
getting the results that I am, I was thinking about this. And also many 
programmers I meet now, do not have the connection to this, and to my 
annoyance, often hardwire things, I would have finetuned, and use more 
complex high-level constructs than neccesary, which makes their results 
poorer. Slower, less graceful.

What I thought was, one needs to try and protect that "vintage" 
experience somewhat.

Lets say if one writes a basic language, that can also carry variables 
into new routines, that gets kernel-access to the hardware.

So that basically you can do Poke53281,0, and change the color of the 
screen, etc. Or for more correctness use a language like Set53281,0. And 
instead of peek53281,var, Get53281, var. Etc. Print "hello", could 
ofcourse also be Display "Hello", for instance. And try to get a very 
easily read "basic" language, with basic functionality for most things.

Something I also later liked on the Amiga 500, was wellnamed commands, 
and intuitive syntaxes.

You´d have this whole interactive experience, available for enthusiasts, 
hackers and engineers, back again. To not speak of rapid prototyping.

I think that would be really good.

The basic could ofcourse also have a compile button.

And I really do think if one reduces the amount of complexity as much as 
possible, and retain "basic" functionality, that one really can do most 
of the stuff neccesary with, I think many more will be programmers, and 
make the software of the future.

Also probably, a kind of "minimal" subset of a GUI API would be good, or 
simply just functions in the basic-language. But enough for anyone to 
make the software they want ofcourse. Buttons, scrolling, scrollbars, 
gracefully editable information in the GUI, etc.

One thing I really hate, is C++ programmers, (maybe not so true for C 
programmers) that obscure things, and talk about wild highlevel theory, 
and fail to see the point of how simple code performs better, is better, 
and often is closer to how a real model works.

For instance in DSP programming circles, I sometimes meet people, who 
say "they are going to measure the impulse response of the analog synth 
X filter, to get the right frequency response, because analogs are so 
weird and strange". And then they talk about wild filter theorems, and 
end up with a complex filter, with high level structures taking all of 
this into account, than can only be called every 60hz because it is so 
CPU expensive. And this is even sold as a product.

And then you look at the original analog. And see four cascaded analog 
sections. That is the simplest thing there is. That is four onepoles in 
parallel, and can be done with four lines of code. And then you look at 
the other guys code, and see several .cs and .cpps with a lot of obscurity.

I don´t know what is happening. In scholastic pursuits maybe 
understanding the whole theory is good. But as a hacker, one simply 
ignores all that, and goes for the optimal solution. Four lines of code, 
that is it, in that example.

And that sounds good. I am sure most have heard about "the 303". It has 
been discussed so much online, and these arguments are used in that 
discussion. But ignoring all the theory, and just going for a four-line 
filter (+ clipped rez) I got immediately very good results. I later also 
added a few things to that, such as bias, and a simple one-pole "low 
emph" setting, that emphasises low-frequencies. This makes the filter 
sounds very smooth, in the saturating rez.

The soundexample, speaks for itself. 
http://paradoxuncreated.com/Blog/wordpress/?p=1371

How many tried to do this, and failed, and contributed to the discussion 
that "analog" was better than "digital", and so many odd things stated. 
What is stopping people? Are they lost in high-level constructs and wild 
theory?

Instead obviously, only with my programming experience from my c64, I 
got better results.

Something to think about.

Peace Be With You.

