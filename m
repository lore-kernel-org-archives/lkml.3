Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab3GSMPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:15:48 -0400
Received: from fep13.mx.upcmail.net ([62.179.121.33]:59599 "EHLO
	fep13.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759912Ab3GSMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:15:47 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <51E92DEB.6020506@odi.ch>
Date: Fri, 19 Jul 2013 14:15:39 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
References: <51E4501D.3010001@odi.ch> <20130716065626.GA1587@redhat.com> <51E4F790.6090308@odi.ch> <51E51712.4020609@broadcom.com> <51E58FA5.4000804@odi.ch> <20130717122944.GA25894@redhat.com> <51E6E1AB.5010300@odi.ch> <20130718105550.GA4628@redhat.com> <51E83AB7.6020002@odi.ch> <20130719120842.GA1570@redhat.com>
In-Reply-To: <20130719120842.GA1570@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19.07.2013 14:08, Stanislaw Gruszka wrote:
> Does crash happen on any suspend or on second one ?

The crash always happens on the first suspend.

Thanks for the patch, I will send results tonight.

Ortwin
