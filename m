Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab3CGPBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:01:30 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:44751 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3CGPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:01:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Mar 2013 10:00:47 -0500
From: shea@shealevy.com
To: Matt Fleming <matt.fleming@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-efi@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: Problem mounting efivarfs in 3.9
In-Reply-To: <20130307145601.GA24233@thinkpad-t410>
References: <20130307145601.GA24233@thinkpad-t410>
Message-ID: <2fd64c1f6943602b91c8f28a45243e20@shealevy.com>
User-Agent: Roundcube Webmail/0.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On 2013-03-07 09:56, Seth Forshee wrote:
> Hi Matt,
>
> I found myself unable to mount efivarfs on one of my machines in 3.9.
> This is due to your patch to be more aggressive about validating
> filenames. This machine had some crash dumps from pstore, which start
> with "dump-type". However now efivars expects the guid to follow the
> first '-' character, despite the fact that the efivars pstore code is
> creating the file names starting with dump-type. Since these names 
> fail
> the validation the mount fails.
>

A fix for this is already in mfleming/efi.git: 
http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=urgent&id=123abd76edf56c02a76b46d3d673897177ef067b 
. It's included in the efi-for-3.9-rc2 tag, and cc'd stable.

Cheers,
Shea Levy
