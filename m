Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaGNDoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 23:44:46 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52688 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaGNDoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 23:44:39 -0400
MIME-Version: 1.0
Date: Sun, 13 Jul 2014 23:44:39 -0400
Message-ID: <CAPDOMVip8ZM2B17ax6O4mMR2iL5nRJyUcP8-sk+5nf7oHdbegQ@mail.gmail.com>
Subject: Fix mes in arch/cris/arch-v32/kernel/kgdb.c
From: Nick Krause <xerofoify@gmail.com>
To: starvik@axis.com
Cc: jesper.nilsson@axis.com, linux-cris-kernel@axis.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the file arch/cris/arch-v32/kernel/kgdb.c , I am hitting a few fix
mes that need to be fixed for kgdb support of this
subsystem architecture of cris. Below this message are the lines of
code and their respective Fix Me messages.
When you around to it I would like to known how you would like these
to be fixed.
Cheers Nick
Fix Mes
------------
1.   /* FIXME: Check the documentation. */ on line 22
2. 437 /* BUFMAX defines the maximum number of characters in
   438    inbound/outbound buffers */
   439 /* FIXME: How do we know it's enough? */
   440 #define BUFMAX 512
3. 467 /* Use an internal stack in the breakpoint and interrupt
response routines.
   468    FIXME: How do we know the size of this stack is enough?
  469    Global so it can be reached from assembler code. */
4.885                 if (S & 1) {
   886                        /* Instruction watchpoint. */
   887                       /* FIXME: Check against, and possibly
adjust reported EDA. */
5. 1410
    1411                                 if (input_buffer[1] != '\0') {
    1412                                         /* FIXME: Doesn't
handle address argument. */
    1413
gdb_cris_strcpy(output_buffer, error_message[E04]);
    1414                                         break;
    1415                                  }
6.1436                                 if (input_buffer[1] != '\0') {
   1437                                         /* FIXME: Doesn't
handle address argument. */
   1438
gdb_cris_strcpy(output_buffer, error_message[E04]);
   1439                                         break;
   1440                                 }
7.   1436                                 if (input_buffer[1] != '\0') {
      1437                                         /* FIXME: Doesn't
handle address argument. */
      1438
gdb_cris_strcpy(output_buffer, error_message[E04]);
      1439                                        break;
      1440                                 }
