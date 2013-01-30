Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3A3NB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:01:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab3A3NB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:01:57 -0500
Message-ID: <51091998.9010704@redhat.com>
Date: Wed, 30 Jan 2013 14:01:12 +0100
From: Roman Rakus <rrakus@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lingzhu Xiang <lxiang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: set_termios/set_termiox should not return -EINTR
References: <20130129190720.GA28000@redhat.com> <20130129190741.GA28004@redhat.com> <51082470.2070601@suse.cz> <20130129194908.GA29480@redhat.com> <510846AB.8010900@suse.cz>
In-Reply-To: <510846AB.8010900@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 11:01 PM, Jiri Slaby wrote:
> E.g. why it started causing problems right now. The code is there
> like forever.
Because right now the situation occurs. It's not common to receive 
signal during syscall. But when it happens, it should work as documented.

RR
