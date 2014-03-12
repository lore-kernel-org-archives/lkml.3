Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaCLLa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:30:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33282 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753991AbaCLLa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:30:28 -0400
Message-ID: <53204551.80801@free-electrons.com>
Date: Wed, 12 Mar 2014 12:30:25 +0100
From: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: zmxu@marvell.com, jszhang@marvell.com, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH 2/2] ARM: dts: berlin2q: add the Marvell BG2-Q DMP device
 tree
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com> <1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com> <4569718.jGyZ5WigRr@wuerfel>
In-Reply-To: <4569718.jGyZ5WigRr@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 12:20, Arnd Bergmann wrote:
> On Wednesday 12 March 2014 12:06:04 Antoine Ténart wrote:
>> +
>> +       soc {
>> +               apb@fc0000 {
>> +                       uart0: uart@9000 {
>> +                               status = "okay";
>> +                       };
>> +               };
>> +       };
>> +};
>
>
> No need to duplicate both the label and the hierarchy here. The easiest
> way to do this is just
>
> 	&uart0 {
> 		status = "okay";
> 	};
>
> since you already have the label.

I'll change that.

Thanks for the feedback !

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
