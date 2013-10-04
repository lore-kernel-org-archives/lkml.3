Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3JDFXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 01:23:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63263 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3JDFXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 01:23:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <524E50DB.3060707@roeck-us.net>
Date: Thu, 03 Oct 2013 22:23:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org
CC: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: Tree for Oct 3
References: <20131004010230.GI27287@sirena.org.uk>
In-Reply-To: <20131004010230.GI27287@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 06:02 PM, Mark Brown wrote:
> Hi all,
>
> Better late than never I've uploaded today's linux-next tree to the
> master branch of the repository below:
>
>          git://gitorious.org/thierryreding/linux-next.git
>
> A next-20131003 tag is also provided for convenience.
>
> A few new conflicts today caused by the removal of the h8300
> architecture which I didn't report for triviality.  Several new build
> failures were found as a result of running allmodconfig tests between
> merges all of which have been reported and I'm still carrying the i.MX
> fix that Thierry has been carrying.
>
> Due to the length of time taken to run all the allmodconfigs I skipped
> the defconfig tests; I know Olof has the ARM stuff covered in his
> autobuilder.  I'm going to use allyesconfig tomorrow since that should
> run faster so hopefully I can cover the ARM, i386 and x86_64 configs
> again.
>

I could try to set up the buildbot farm I am using for -stable candidates
to also test the -next tree. Would that help ?

Thanks,
Guenter

