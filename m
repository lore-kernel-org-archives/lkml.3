Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3J3Oja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:39:30 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33471 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab3J3Oj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:39:28 -0400
Date: Wed, 30 Oct 2013 14:39:23 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: matthew.garrett@nebula.com, Jeremy Kerr <jk@ozlabs.org>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Subject: Re: [PATCH] efivarfs: 'efivarfs_file_write' function reorganization
Message-ID: <20131030143923.GA9996@console-pimps.org>
References: <1381775837-26023-1-git-send-email-geyslan@gmail.com>
 <20131030123850.GA8193@console-pimps.org>
 <CAGG-pUQZ2R0JMZuGi07cL5q4EABYouZJfMpkO6YPy+ry2WkbNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGG-pUQZ2R0JMZuGi07cL5q4EABYouZJfMpkO6YPy+ry2WkbNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct, at 10:44:16AM, Geyslan Gregório Bem wrote:
> Do you want that I undo that? I aggre that the variable use only
> reduces the line code.

Yes please.

-- 
Matt Fleming, Intel Open Source Technology Center
