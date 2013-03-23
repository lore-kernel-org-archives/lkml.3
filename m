Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab3CWONp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 10:13:45 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:14685 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3CWONo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 10:13:44 -0400
Message-ID: <514DB895.9010201@tilera.com>
Date: Sat, 23 Mar 2013 10:13:41 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Henrik Austad <haustad@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: ns2cycles should use __raw_get_cpu_var
References: <514CB2E4.2030009@tilera.com> <1364023399-26075-1-git-send-email-haustad@cisco.com>
In-Reply-To: <1364023399-26075-1-git-send-email-haustad@cisco.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/2013 3:23 AM, Henrik Austad wrote:
> +	/* we don't have to disable preemptions here as each core has the same
> +	 * clock-frequency */

Looks OK except the comment is in the wrong style.  Kernel multiline comments

/*
 * Should look
 * like this.
 */

and use full sentences with punctuation.  (Also, don't hyphenate clock frequency here.)  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

