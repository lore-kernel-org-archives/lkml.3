Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaLFDo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 22:44:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaLFDo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 22:44:26 -0500
Date: Fri, 5 Dec 2014 19:44:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.17 000/122] 3.17.5-stable review
Message-ID: <20141206034425.GA3350@kroah.com>
References: <20141205223305.514276242@linuxfoundation.org>
 <54827868.4040100@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54827868.4040100@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 07:30:48PM -0800, Guenter Roeck wrote:
> On 12/05/2014 02:42 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.17.5 release.
> >There are 122 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sun Dec  7 22:32:17 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 133 pass: 132 fail: 1
> Failed builds:
> 	avr32:atngw100mkii_evklcd101_defconfig

Bah, it looks like no one cares about avr32 anymore :(

Anyway, thanks for testing all of these and letting me know.

greg k-h
