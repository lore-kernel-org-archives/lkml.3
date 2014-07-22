Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaGVJDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:03:33 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41017 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaGVJDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:03:30 -0400
Message-ID: <53CE28DB.8080109@gmail.com>
Date: Tue, 22 Jul 2014 12:03:23 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>
CC: Paul Bolle <pebolle@tiscali.nl>, Al Viro <viro@zeniv.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        pramod.gurav.etc@gmail.com, Jason Cooper <jason@lakedaemon.net>,
        Markus Mayer <markus.mayer@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] direct-io: fix uninitialized warning in do_direct_IO()
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com> <20140713115022.GA6054@infradead.org> <53C6B199.2070606@gmail.com> <20140716175803.GA3631@infradead.org> <1405536124.4357.17.camel@x41> <53C79949.7010201@gmail.com> <53C7AF58.5030807@gmail.com> <1405596599.5735.11.camel@x41> <53CB8730.40607@plexistor.com> <20140721113653.GC2628@infradead.org>
In-Reply-To: <20140721113653.GC2628@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 02:36 PM, Christoph Hellwig wrote:
> Looks good to me,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> While it looks obvious, did you make sure it passes xfstests, which
> has a lot of direct I/O tests?
> 

Thank you Christoph. OK So finally I did last night. I ran
ext4. Just that I'm not used to run ext4 or any of those
stuff so it took me time. I have the usual 2 failures I get
also from 3.15. So I'd say its good - tested

Thanks
Boaz

