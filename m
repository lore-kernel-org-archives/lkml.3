Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaFYEtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:49:19 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55609 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaFYEtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:49:17 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AA54BE.9030206@roeck-us.net>
Date: Tue, 24 Jun 2014 21:49:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Don Fry <pcnet32@frontier.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH V2 08/22] amd: Use pci_zalloc_consistent
References: <cover.1403530604.git.joe@perches.com>  <c7cdaa8e080157cdabb92278a4c3beba89b49070.1403530604.git.joe@perches.com>  <1403546524.12008.2.camel@Lunix2.home>  <1403550950.15811.15.camel@joe-AO725> <1403557507.20657.3.camel@joe-AO725>
In-Reply-To: <1403557507.20657.3.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 02:05 PM, Joe Perches wrote:
> Remove the now unnecessary memset too.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> On Mon, 2014-06-23 at 12:15 -0700, Joe Perches wrote:
>> On Mon, 2014-06-23 at 11:02 -0700, Don Fry wrote:
>>> This causes the line length to be greater than 80 characters causing
>>> checkpatch to complain.
>
> V2: Don Fry is an 80 column neatnik.
>

And you are an 'align with (' neatnik, so guess the two of you are even :-)

Guenter

