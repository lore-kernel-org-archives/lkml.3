Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030542AbaLLQBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:01:39 -0500
Received: from wolff.to ([98.103.208.27]:40594 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030502AbaLLQBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:01:38 -0500
Date: Fri, 12 Dec 2014 09:56:05 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: toki clover <tokiclover@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, texstar@gmail.com, martin@mvath.de,
        Guan Xin <guanx.bac@gmail.com>, dave@vasilevsky.ca, szycha@gmail.com,
        blyons@students.naropa.edu, afm404@gmail.com, hugochevrain@gmail.com
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
Message-ID: <20141212155605.GA31859@wolff.to>
References: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk>
 <CAGw_SrN6tZyXRx6pxkpnhWc2U5845HRbfzhOK5v9qkjWejFpmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGw_SrN6tZyXRx6pxkpnhWc2U5845HRbfzhOK5v9qkjWejFpmA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 13:23:19 +0100,
  toki clover <tokiclover@gmail.com> wrote:
>
>Now, I did not see any Linux FS devs activity/response to this... What
>a waste of time because if those patch don't make it for this merge
>window, rebasing/reposting will be, again, necessary.

The patches got pulled into linux-next. For XZ, the patches sat in 
linux-next for a full release cycle. I don't know whether or not 
if that is the plan for the lz4 patches.
