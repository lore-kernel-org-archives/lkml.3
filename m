Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3CFNbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:31:16 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:63569 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3CFNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:31:13 -0500
MIME-Version: 1.0
In-Reply-To: <51366C77.3080309@semaphore.gr>
References: <51366C77.3080309@semaphore.gr>
Date: Wed, 6 Mar 2013 21:31:13 +0800
Message-ID: <CAKohponFw+nvzQAj58-gpxu8rUudm9gG+OQ8nK=Qi9BONcpAZw@mail.gmail.com>
Subject: Re: [PATCH 3/3 linux-next] cpufreq: conservative: Use an inline
 function to evaluate freq_target
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2013 06:06, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Use an inline function to evaluate freq_target to avoid duplicate code.
>
> Also, define a macro for the default frequency step and fix the
> calculation of freq_target when the max freq is less that 100.

s/that/than :)
