Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbaJ2WQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:16:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbaJ2WQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:16:15 -0400
Date: Wed, 29 Oct 2014 15:15:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, marcel@holtmann.org,
        desrt@desrt.ca, hadess@hadess.net, dh.herrmann@gmail.com,
        tixxdz@opendz.org, simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
Message-ID: <20141029221505.GA7812@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 03:00:44PM -0700, Greg Kroah-Hartman wrote:
> kdbus is a kernel-level IPC implementation that aims for resemblance to
> the the protocol layer with the existing userspace D-Bus daemon while
> enabling some features that couldn't be implemented before in userspace.

{sigh}

I'll blame it on the jet-lag for the lack of [XX/12] markings on the
patches.  I'll give it a day for review before resending if people
really want to know the ordering.  It doesn't matter except for the
final patch that adds the code to the build file.

sorry about that,

greg k-h
