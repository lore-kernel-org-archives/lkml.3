Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbaGWWzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:55:06 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65091 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992AbaGWWzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:55:03 -0400
Date: Wed, 23 Jul 2014 15:55:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Theodore Ts'o" <tytso@mit.edu>, Olof Johansson <olof@lixom.net>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/ext4/super.c: Let 'counters' switched by SMP
In-Reply-To: <20140721191148.GB24960@thunk.org>
Message-ID: <alpine.DEB.2.02.1407231554450.1389@chino.kir.corp.google.com>
References: <53C47E59.8030502@gmail.com> <20140715093154.GB1451@thunk.org> <CAOesGMhmENA+eojUYBOCJQBNq4zcWx8C-qDCv5umNPm0it8qxg@mail.gmail.com> <20140721191148.GB24960@thunk.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Theodore Ts'o wrote:

> Right, sorry, I'm currently in vacation in Rome, and the network
> connection was really lousy here now that I'm no longer at the ACACES
> summer school in Fiuggi.  (Also, now that I'm no longer actually
> teaching, I've beeen trying to actually do the disconnecting and
> sightseeing thing.  :-)
> 

Confirmed this is now fixed in linux-next, thanks Ted!
