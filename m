Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaBYSjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:39:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58542 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbaBYSjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:39:13 -0500
Message-ID: <530CE320.6000808@zytor.com>
Date: Tue, 25 Feb 2014 10:38:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
CC: ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz
Subject: Re: [PATCH 08/11] kexec-bzImage: Support for loading bzImage using
 64bit entry
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com> <1390849071-21989-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1390849071-21989-9-git-send-email-vgoyal@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 10:57 AM, Vivek Goyal wrote:
> This is loader specific code which can load bzImage and set it up for
> 64bit entry. This does not take care of 32bit entry or real mode entry
> yet.

Is there any use in that?  Real mode entry especially is more than a bit
scary when coming from another kernel already...

	-hpa


