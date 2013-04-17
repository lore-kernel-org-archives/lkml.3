Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3DQEiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 00:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab3DQEiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 00:38:05 -0400
Message-ID: <516E2717.3020309@redhat.com>
Date: Wed, 17 Apr 2013 12:37:43 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: Seiji Aguchi <seiji.aguchi@hds.com>, Matt Fleming <matt.fleming@intel.com>,
        Josh Boyer <jwboyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Michael Schroeder <mls@suse.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 097/102] efivars: explicitly calculate length of VariableName
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com> <1365414657-29191-98-git-send-email-luis.henriques@canonical.com> <1365547506.5814.36.camel@deadeye.wl.decadent.org.uk> <51653E81.4090102@redhat.com> <20130410121730.GB3049@hercules> <A5ED84D3BB3A384992CBB9C77DEDA4D41AF8D09E@USINDEM103.corp.hds.com> <20130411091256.GA11370@hercules> <20130416103321.GB3054@hercules>
In-Reply-To: <20130416103321.GB3054@hercules>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 06:33 PM, Luis Henriques wrote:
> 68d929862e29a8b52a7f2f2f86a0600423b093cd efi: be more paranoid about available space when creating variables

This prevents a bricking issue for some Samsung devices but causes 
regression on many other machines.

https://bugzilla.kernel.org/show_bug.cgi?id=55471
https://bugzilla.redhat.com/show_bug.cgi?id=947142
http://article.gmane.org/gmane.linux.kernel.efi/1078
http://article.gmane.org/gmane.linux.kernel.stable/47150

This patchset will fix it again:

http://thread.gmane.org/gmane.linux.kernel.efi/1081

