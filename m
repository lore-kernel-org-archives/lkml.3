Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaCKRRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:17:33 -0400
Received: from smtprelay0179.hostedemail.com ([216.40.44.179]:44624 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754586AbaCKRRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:17:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: stone00_1fd3da0c80f49
X-Filterd-Recvd-Size: 1624
Message-ID: <1394558212.21085.57.camel@joe-AO722>
Subject: Re: [PATCH v2] cpufreq: Reformat printk() statements
From: Joe Perches <joe@perches.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 11 Mar 2014 10:16:52 -0700
In-Reply-To: <531F441C.5070107@gmail.com>
References: <1394557380-15054-1-git-send-email-soren.brinkmann@xilinx.com>
	 <531F441C.5070107@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 10:13 -0700, Dirk Brandewie wrote:
> On 03/11/2014 10:03 AM, Soren Brinkmann wrote:
> > From: Joe Perches <joe@perches.com>
> >   - Add missing newlines
> >   - Coalesce format fragments
> >   - Convert printks to pr_<level>
> >   - Align arguments
> This introduces a bunch of lines over 80 charaters long.

Intentionally.

from: Documentation/CodingStyle

		Chapter 2: Breaking long lines and strings

Coding style is all about readability and maintainability using commonly
available tools.

[]

never break user-visible strings such as
printk messages, because that breaks the ability to grep for them.


