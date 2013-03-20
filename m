Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3CTTZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:25:33 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53713 "EHLO
	mail.izyk.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3CTTZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:25:32 -0400
Message-ID: <514A0D28.4060804@izyk.ru>
Date: Wed, 20 Mar 2013 23:25:28 +0400
From: Ilya Zykov <linux@izyk.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Min Zhang <mzhang@mvista.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/18] tty: Simplify tty buffer/ldisc interface with helper
 function
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>   <1363724513-15604-4-git-send-email-peter@hurleysoftware.com>   <5148E9D2.4030305@izyk.ru> <1363737036.3413.49.camel@thor.lan>  <5149AFD0.8020604@izyk.ru> <1363801796.4280.24.camel@thor.lan>
In-Reply-To: <1363801796.4280.24.camel@thor.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.03.2013 21:49, Peter Hurley wrote:
> The motivation for changing the workqueue api to allow parallel work
> items on SMP was to fix a class of deadlocks where forward progress
> could not be made due to subtle dependencies between work items
> (actually that potential still exists with self-modifying work-items,
> ie., work items that change their function).
> 
> The tty layer would need a detailed and thorough analysis of potential
> dependencies to avoid creating problems. The drivers that use work items
> might need examination as well.

Sorry, but I don't understand.
My knowledge is very weak.

We say about three works:
hangup_work, SAK_work, buf.work
or anything else?

