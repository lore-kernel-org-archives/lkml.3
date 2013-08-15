Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab3HOQpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:45:43 -0400
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:43511 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757689Ab3HOQpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <52025BE3.5020002@redhat.com>
References: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com>
 <1375750501-21902-1-git-send-email-roland@kernel.org> <52025BE3.5020002@redhat.com>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 15 Aug 2013 09:45:19 -0700
X-Google-Sender-Auth: EEoqJUCDzpoTnQfnXfovoJNE1O8
Message-ID: <CAL1RGDVktaz4Y4_bB+uTzjk0R1+RgwF7DNuZ_+zvpLvH90oTQA@mail.gmail.com>
Subject: Re: [PATCH v2] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
To: David Milburn <dmilburn@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>,
        James Bottomley <JBottomley@parallels.com>,
        Costa Sapuntzakis <costa@purestorage.com>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        David Jeffery <djeffery@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens / James, do you guys plan to send this to Linus for 3.11?
Triggering this bug is a bit esoteric but the impact is pretty nasty
(corrupting an unrelated process).

Thanks,
  Roland
