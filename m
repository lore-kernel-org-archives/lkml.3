Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966792Ab3DQOvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:51:35 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37990 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966779Ab3DQOve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:51:34 -0400
Message-ID: <516EB6F2.6070806@console-pimps.org>
Date: Wed, 17 Apr 2013 15:51:30 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Matt Fleming <matt.fleming@intel.com>, joeyli <jlee@suse.com>,
        matthew.garrett@nebula.com, cbouatmailru@gmail.com, ccross@android.com,
        keescook@chromium.org, Tony Luck <tony.luck@intel.com>,
        linux-efi@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Cannot add new efi boot entry
References: <516B1ED3.9040900@suse.cz> <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com> <516EB1B6.7050506@suse.cz>
In-Reply-To: <516EB1B6.7050506@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/04/13 15:29, Jiri Slaby wrote:
> On 04/16/2013 12:11 PM, Matt Fleming wrote:
>> On 16/04/13 10:56, joeyli wrote:
>>> I think I just got the same situation on my side with Acer machine. I am
>>> trying Matthew's new patchset hope can avoid this situation:
>>>
>>> https://lkml.org/lkml/2013/4/15/473
>>
>> Please do let us know whether the patches work for you.
> 
> Hmm, where did efi_query_variable_store in 3/3 come from?

It's in a patch on the 'urgent' branch at,

    git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

-- 
Matt Fleming, Intel Open Source Technology Center
