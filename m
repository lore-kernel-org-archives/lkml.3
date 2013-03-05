Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3CEWLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:11:54 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44047 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab3CEWLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:11:53 -0500
Message-ID: <51366DA3.1080500@suse.cz>
Date: Tue, 05 Mar 2013 23:11:47 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
References: <20130305.150338.470704111422696046.davem@davemloft.net> <5136554F.3060006@suse.cz> <20130305.153358.503062411029894196.davem@davemloft.net> <20130305.153450.1686180125402560098.davem@davemloft.net> <513666F6.2000400@suse.cz>
In-Reply-To: <513666F6.2000400@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 10:43 PM, Jiri Slaby wrote:
> send a fix for this one).

Hmm, did it work before actually? Even though the change was
unintentional and undocumented, it fixed the sysrq handling as far as I
can tell.

-- 
js
suse labs
