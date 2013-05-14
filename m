Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3ENRQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:16:30 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42555 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab3ENRQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:16:28 -0400
Message-ID: <51927159.8090300@linux.vnet.ibm.com>
Date: Tue, 14 May 2013 10:16:09 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] checkpatch: avoid warning on page flag acessors
References: <1368549951-1170-1-git-send-email-cody@linux.vnet.ibm.com> <1368551211-6213-1-git-send-email-cody@linux.vnet.ibm.com> <1368551598.23335.4.camel@joe-AO722>
In-Reply-To: <1368551598.23335.4.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051417-9360-0000-0000-0000122A3287
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 10:13 AM, Joe Perches wrote:
> I think you need to delete the ", leave the | and remove the ?
> Dunno where that " came from.

Ya. commit goof on my part, see v3

