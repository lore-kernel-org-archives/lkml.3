Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaDCES4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 00:18:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61624 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaDCESy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 00:18:54 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <533CE12B.2080301@roeck-us.net>
Date: Wed, 02 Apr 2014 21:18:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 00/40] 3.12.17-stable review
References: <cover.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 01:12 PM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.17 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Apr  4 20:06:31 2014
> Anything received after that time might be too late.
>

Build results:
	total: 126 pass: 121 skipped: 5 fail: 0

qemu tests all passed. Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

