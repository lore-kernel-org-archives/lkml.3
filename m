Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3CKWf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:35:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3CKWf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:35:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 9/9] ARM: spear3xx: Use correct pl080 header file
Date: Mon, 11 Mar 2013 22:34:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Alessandro Rubini <rubini@gnudd.com>,
        "spear-devel" <spear-devel@list.st.com>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de> <1362521809-22989-10-git-send-email-arnd@arndb.de> <CAKohponFisFjM9CbpHoR7h-pn1SAOWeck63v3FKZe4UV0cR2DQ@mail.gmail.com>
In-Reply-To: <CAKohponFisFjM9CbpHoR7h-pn1SAOWeck63v3FKZe4UV0cR2DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303112234.55748.arnd@arndb.de>
X-Provags-ID: V02:K0:j/UFjv9aKZyrXIPEgaW8RcnN90qvrMavCtvn5gzysO1
 P61auOBij4urW4wpk2qI0w5F8zGRpr3Ml3kFPwRhtSNuLOK+9G
 FbZH44ytEYALZl0dAzVoj7JP0wKMZP6//LT4p4kmzLLnoU8JaB
 t/e3yDkZYmlsDBGNLIb0bsAl64OojIQzppNILwRi6n1Ebqn0WD
 4RvBevMv1EgAPa8yKe1tv5O8sv7Dfq8oszpUDD+jxNgBx0Q3NX
 TTTYs6A8kZauUaHlLF8qSid3tjyGdayXBfyQYoafNZi+kUgGjl
 A66rtj3VnxQU3Bhiby6ZpGCv3COe4DVkiM4qO/LYJegLaH36sj
 /E6ejLBxaeCZtrB9yllY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013, Viresh Kumar wrote:
> On 6 March 2013 06:16, Arnd Bergmann <arnd@arndb.de> wrote:
> > The definitions have move around recently, causing build errors
> > in spear3xx for all configurations:
> >
> > spear3xx.c:47:5: error: 'PL080_BSIZE_16' undeclared here (not in a function)
> > spear3xx.c:47:23: error: 'PL080_CONTROL_SB_SIZE_SHIFT' undeclared here (not in a function)
> > spear3xx.c:48:22: error: 'PL080_CONTROL_DB_SIZE_SHIFT' undeclared here (not in a function)
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Alessandro Rubini <rubini@gnudd.com>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  arch/arm/mach-spear3xx/spear3xx.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> You are a bit late in posting this.
> We already got the same patch from Vipul yesterday :)

Are you going to send a pull request for that one then? Another -rc has
just passed with the platform being broken.

	Arnd
