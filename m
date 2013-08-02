Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3HBLC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:02:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab3HBLC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:02:28 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_6S4gJz81GoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UirpL7NoV14A:10 a=mwMkYO5XIq_0_x-oQ7cA:9 a=QEXdDO2ut3YA:10 a=GV1duZIgHnkA:10 a=0p_QRJGIAhIA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375441345.22073.0.camel@gandalf.local.home>
Subject: Re: __ftrace_hash_rec_update FTRACE_WARN_ON.
From: Steven Rostedt <rostedt@goodmis.org>
To: Steve Hodgson <steve@purestorage.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 02 Aug 2013 07:02:25 -0400
In-Reply-To: <CADHUQJ5L54YihGsB-WgOggN257FRetoFy4zsqK2GGtaXzMrxKQ@mail.gmail.com>
References: <20130705142629.GA325@redhat.com>
	 <1373036034.22688.155.camel@gandalf.local.home>
	 <20130724160422.GA3641@logfs.org>
	 <1374715444.3356.163.camel@gandalf.local.home>
	 <CADHUQJ4yweA4zNKqtsq=iQkX+o6UmA-dwWV1d-0SdJbpGtZR5A@mail.gmail.com>
	 <1374778741.3356.181.camel@gandalf.local.home>
	 <1374808998.6580.12.camel@gandalf.local.home>
	 <CADHUQJ5=cgWsAvUb29EVnnP2gKeeoNnp=4gLuJqq+wQh+iBYzw@mail.gmail.com>
	 <1375231885.25784.2.camel@gandalf.local.home>
	 <CADHUQJ5L54YihGsB-WgOggN257FRetoFy4zsqK2GGtaXzMrxKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 21:51 -0700, Steve Hodgson wrote:

> This patch also fixes the issue for me: ftrace works fine across module removal.
> 
> Sorry for being a little slow in testing this.
> 

No problem. Thanks for testing :-)

-- Steve


