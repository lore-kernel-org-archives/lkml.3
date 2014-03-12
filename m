Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaCLLUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:20:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaCLLUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:20:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, zmxu@marvell.com, jszhang@marvell.com,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com
Subject: Re: [PATCH 2/2] ARM: dts: berlin2q: add the Marvell BG2-Q DMP device tree
Date: Wed, 12 Mar 2014 12:20:01 +0100
Message-ID: <4569718.jGyZ5WigRr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com> <1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:NBIv3oUjf9O+2yqHRMMu6gXNuqdh+lj6Cjzx6wO8Jj8
 bDGynV8+3CQRHISHtTMJfn/dMLfwLB0030TilR/g6Ak+JQfS/l
 /cQX+TNffMst89VsesyWGm5dFnsGqy1NI2JNcNiuua7W6N9Tul
 2GGVphqlGHDNYH29AL82em4J5x+/mqMejHzX6JO24yHbkqc6tp
 k4zcCBCYMwggYRW8Pz0LBy4ly6pYKOKrGlaOVgRiCTOT303C1y
 GaHecNzWzCHvHW7si+iXnIbuoD8HhDnGuH8F/yt9Nn0hRaNhMz
 RSzSGNr2EV7q9A7nL5/sPjREB2Pb8s8SWYGgtNnneL5+cSZvgu
 LKVLfXq9lxbf3WNEu7a8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2014 12:06:04 Antoine Ténart wrote:
> +
> +       soc {
> +               apb@fc0000 {
> +                       uart0: uart@9000 {
> +                               status = "okay";
> +                       };
> +               };
> +       };
> +};


No need to duplicate both the label and the hierarchy here. The easiest
way to do this is just

	&uart0 {
		status = "okay";
	};

since you already have the label.

	Arnd
