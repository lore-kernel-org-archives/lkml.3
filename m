Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423643Ab3FVC1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 22:27:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56118 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754394Ab3FVC1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 22:27:24 -0400
Message-ID: <1371868042.2086.0.camel@joe-AO722>
Subject: Re: [PATCHv v3] power: Include additional information in
 pm_print_times
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Shuah Khan <shuah.kh@samsung.com>, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Fri, 21 Jun 2013 19:27:22 -0700
In-Reply-To: <2534796.mOHH0DCD2A@vostro.rjw.lan>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
	 <2534796.mOHH0DCD2A@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-22 at 02:24 +0200, Rafael J. Wysocki wrote:
> Namely, there are tools that use these messages to create suspend/resume time
> charts and they will stop working after the proposed changes.

dmesg output isn't guaranteed to be stable.


