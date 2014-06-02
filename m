Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaFBQHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:07:10 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64264 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaFBQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:07:07 -0400
Message-ID: <538CA125.7090906@gmail.com>
Date: Mon, 02 Jun 2014 19:07:01 +0300
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/base: Replace alias if it already exists
References: <1401624083-30796-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <20140602145959.7E669C426F6@trevor.secretlab.ca>
In-Reply-To: <20140602145959.7E669C426F6@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On  2.06.2014 17:59, Grant Likely wrote:
> On Sun,  1 Jun 2014 15:01:23 +0300, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> wrote:
>> The current code unconditionally adds aliases without check if it already
>> exists, so it is not possible to alter an alias, from board DT file for
>> example. Fix that by replacing an alias if it already exists
>>
>
> Can you describe a more detailed use-case for altering an alias?
>
> g.
>

That one http://www.spinics.net/lists/linux-omap/msg107869.html

Ivo
