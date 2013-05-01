Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3EARyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:54:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46329 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab3EARyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:54:45 -0400
Message-ID: <518156D3.8020909@zytor.com>
Date: Wed, 01 May 2013 10:54:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "Theodore Ts'o" <tytso@mit.edu>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't already
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net> <20130501113352.GA29571@pd.tnic> <20130501163404.GA6286@thunk.org> <518145F6.3060800@zytor.com> <CALCETrX0WEGJ0UZz6PyQ4DrnpGg52S0cArDYLQ9Yjz3uic_N4A@mail.gmail.com> <51815252.4010103@zytor.com> <CALCETrWa64s2bMVq9xJ5FBg2NH8501V-YThVO7CrJa7-0-TVHg@mail.gmail.com>
In-Reply-To: <CALCETrWa64s2bMVq9xJ5FBg2NH8501V-YThVO7CrJa7-0-TVHg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 10:50 AM, Andy Lutomirski wrote:
> 
> Isn't the upper half incompatible with large pages?
> 

No, just with attributes *on the page tables themselves*.

	-hpa

