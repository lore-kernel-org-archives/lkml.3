Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaJ2DDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:03:44 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:55132 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751993AbaJ2DDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:03:43 -0400
Message-ID: <54505905.9020501@daenzer.net>
Date: Wed, 29 Oct 2014 12:03:33 +0900
From: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:32.0) Gecko/20100101 Icedove/32.0
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>, Joe Perches <joe@perches.com>
CC: Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/11 V2] radeon: evergreen: Fix probable mask
 then right shift defect
References: <cover.1414387334.git.joe@perches.com> <88c64cce88264069e0e1637fc874e699e5b226f6.1414387334.git.joe@perches.com> <544E0D0E.6080206@daenzer.net> <1414419297.8884.5.camel@perches.com> <CADnq5_PCaBUMrUTAXJ5DswQR0jajoEJoAa-Jjhz79OrZUn6XGw@mail.gmail.com>
In-Reply-To: <CADnq5_PCaBUMrUTAXJ5DswQR0jajoEJoAa-Jjhz79OrZUn6XGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.2014 23:06, Alex Deucher wrote:
> On Mon, Oct 27, 2014 at 10:14 AM, Joe Perches <joe@perches.com> wrote:
>> Precedence of & and >> is not the same and is not left to right.
>> shift has higher precedence and should be done after the mask.
>>
>> Add parentheses around the mask.
>>
>> Use the already #defined values instead of hardcoding.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>> I think this should be NUM_SHADER_ENGINES_SHIFT?
>>
>> (Joe can't type)
>>
>> exactly right, thanks Michel
>
> Applied with a compile fix.

Joe, in the future please make sure your patches compile before 
submitting them.


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
