Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaKFVo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:44:57 -0500
Received: from www.sr71.net ([198.145.64.142]:49200 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaKFVo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:44:56 -0500
Message-ID: <545BEBD6.4030803@sr71.net>
Date: Thu, 06 Nov 2014 13:44:54 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org
CC: Aristeu Rozanski <arozansk@redhat.com>, Changli Gao <xiaosuo@gmail.com>,
        David Rientjes <rientjes@google.com>, Eric Paris <eparis@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Jesse Gross <jesse@nicira.com>, Jonathan Corbet <corbet@lwn.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pravin Shelar <pshelar@nicira.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] lib/flex_array: make build optional
References: <1415309241-12971-1-git-send-email-aris@redhat.com> <545BE927.9060208@sr71.net>
In-Reply-To: <545BE927.9060208@sr71.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 01:33 PM, Dave Hansen wrote:
> On 11/06/2014 01:27 PM, Aristeu Rozanski wrote:
>> +config FLEX_ARRAY
>> +	bool "Flexible array"
>> +	default n
>> +	help
>> +	  This option enables an implementation of flexible arrays which
>> +	  allows creating arrays of fixed size elements with an arbritrary
>> +	  size without requiring the single allocation of a contiguous area.
>> +
>> +	  See Documentation/flexible-arrays.txt
> 
> Is there any reason to expose this to the user via Kconfig?
> 
> No sane person would even turn it on if they don't need it.

IOW, I think you should just make it:

config FLEX_ARRAY
	def_bool n

