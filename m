Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3AVSRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:17:54 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:9324 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3AVSRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:17:52 -0500
Message-ID: <50FED7CE.1030008@hp.com>
Date: Tue, 22 Jan 2013 10:17:50 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Leandro Lucarella <leandro.lucarella@sociomantic.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Doubts about listen backlog and tcp_max_syn_backlog
References: <20130122161038.GG4608@sociomantic.com> <1358873142.3464.3964.camel@edumazet-glaptop> <20130122165929.GH4608@sociomantic.com> <1358874800.3464.4002.camel@edumazet-glaptop>
In-Reply-To: <1358874800.3464.4002.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> What is important is the backlog, and I guess you didn't increase it
> properly. The somaxconn default is quite low (128)

Leandro -

If that is being overflowed, I believe you should be seeing something like:

     14 SYNs to LISTEN sockets dropped

in the output of netstat -s on the system on which the server 
application is running.

rick
