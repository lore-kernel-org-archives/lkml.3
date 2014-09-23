Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaIWNQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:16:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbaIWNQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:16:09 -0400
Message-ID: <54217298.1090409@suse.cz>
Date: Tue, 23 Sep 2014 15:16:08 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Matteo Croce <matteo@openwrt.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 generated files in gitignore
References: <CAFnufp3DcbG1DjXjD-sTL=1wYzu9dS5r1UXxGQwQjR11zRSBfg@mail.gmail.com> <20140923124045.GA13913@sepie.suse.cz> <CAFnufp2DQvEywZW0sg-+hLyeDY+L0UwWjEtDwX-PgOJWda-HOw@mail.gmail.com>
In-Reply-To: <CAFnufp2DQvEywZW0sg-+hLyeDY+L0UwWjEtDwX-PgOJWda-HOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please do not top-post)

On 2014-09-23 14:57, Matteo Croce wrote:
> Didn't know, thanks.
> 
> What about arch/x86/purgatory?

That part of the patch seems fine, but it should be sent to the x86
maintainers.

Michal
